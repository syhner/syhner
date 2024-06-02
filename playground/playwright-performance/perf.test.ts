import test, { type CDPSession } from "playwright/test";
import fs from "fs/promises";

let cdpSession: CDPSession;

test.beforeEach(async ({ page, browser }, testInfo) => {
  // Traces
  await browser.startTracing(page, { path: "test-results/perf.json", screenshots: true });
  cdpSession = await page.context().newCDPSession(page);

  // Metrics
  await cdpSession.send("Performance.enable");
});

test.afterEach(async ({ page, browser }) => {
  // Traces
  await browser.stopTracing();
  await page.evaluate(() => window.performance.measure("overall"));

  // Metrics
  const performanceMetrics = await cdpSession.send("Performance.getMetrics");
  fs.writeFile("test-results/metrics.json", JSON.stringify(performanceMetrics.metrics, null, 2));

  // Marks & Measures
  const marks = await page.evaluate(() => window.performance.getEntriesByType("mark"));
  const measures = await page.evaluate(() => window.performance.getEntriesByType("measure"));
  await fs.writeFile("test-results/marks.json", JSON.stringify(marks, null, 2));
  await fs.writeFile("test-results/measures.json", JSON.stringify(measures, null, 2));
});

test.describe("CDP Demo", () => {
  test("Get performance metrics", async ({ page }) => {
    await page.goto("https://www.google.fr/");
    await page.evaluate(() => window.performance.mark("afer-navigation"));
    await page.getByRole("button", { name: "Tout accepter" }).click();
    await page.getByLabel("Rech.").fill("Playwright");
    await page.getByRole("button", { name: "Recherche Google" }).click();
    await page.waitForURL("**/search?q=Playwright&**");
  });
});
