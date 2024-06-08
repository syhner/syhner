import type { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, rectangle, shell } from "./utils";

const FILE_NAME = `${__dirname}/../../home/.config/karabiner/karabiner.json`;

const rules: KarabinerRules[] = [
  {
    // Define the Hyper key itself
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        type: "basic",
        description: "Caps Lock -> Hyper Key",
        from: {
          key_code: "caps_lock",
          modifiers: { optional: ["any"] },
        },
        to: [{ set_variable: { name: "hyper", value: 1 } }],
        to_after_key_up: [{ set_variable: { name: "hyper", value: 0 } }],
        to_if_alone: [{ key_code: "escape" }],
      },
      // Use right command as left control
      {
        type: "basic",
        description: "Reachable control key",
        from: { key_code: "right_command" },
        to: [{ key_code: "left_control" }],
      },
      // Arrow keys on home row
      {
        type: "basic",
        description: "Ctrl h -> left",
        from: { key_code: "h", modifiers: { mandatory: ["left_control"] } },
        to: [{ key_code: "left_arrow" }],
      },
      {
        type: "basic",
        description: "Ctrl j -> down",
        from: { key_code: "j", modifiers: { mandatory: ["left_control"] } },
        to: [{ key_code: "down_arrow" }],
      },
      {
        type: "basic",
        description: "Ctrl k -> up",
        from: { key_code: "k", modifiers: { mandatory: ["left_control"] } },
        to: [{ key_code: "up_arrow" }],
      },
      {
        type: "basic",
        description: "Ctrl l -> right",
        from: { key_code: "l", modifiers: { mandatory: ["left_control"] } },
        to: [{ key_code: "right_arrow" }],
      },
    ],
  },
  // Note: Avoid layers which use the same finger as the Hyper key (q, a, z)
  // Note: Avoid sub-layers which use the same finger as the layer
  ...createHyperSubLayers({
    // Browse
    b: {
      t: open("https://twitter.com"),
      y: open("https://news.ycombinator.com"),
    },
    // c: {},
    // d: {},
    // e: {},
    // f: {},
    // g: {},
    // h: {},
    // i: {},
    // j: {},
    // k: {},
    // l: {},
    // m: {},
    // n: {},
    // Open
    o: {
      b: app("Arc"),
      d: app("Discord"),
      f: app("Finder"),
      i: app("Messages"), // Imessage
      k: app("Slack"),
      m: app("Obsidian"), // Markdown
      s: app("Spotify"),
      t: app("Alacritty"),
      v: app("Visual Studio Code"),
      z: app("zoom.us"),
    },
    // p: {},
    // Raycast
    r: {
      a: open("raycast://extensions/raycast/raycast-ai/ai-chat"),
      c: open("raycast://extensions/thomas/color-picker/pick-color"),
      e: open("raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"),
      h: open("raycast://extensions/raycast/clipboard-history/clipboard-history"),
      p: open("raycast://extensions/raycast/raycast/confetti"),
    },
    // s: {},
    // t: {},
    // u: {},
    // moVe / Vim
    v: {
      h: {
        to: [{ key_code: "left_arrow" }],
      },
      i: {
        to: [{ key_code: "page_up" }],
      },
      j: {
        to: [{ key_code: "down_arrow" }],
      },
      k: {
        to: [{ key_code: "up_arrow" }],
      },
      l: {
        to: [{ key_code: "right_arrow" }],
      },
      // scrOll mode (via homerow.app)
      o: {
        to: [{ key_code: "o", modifiers: ["right_control", "right_option"] }],
      },
      // Search mode (via homerow.app)
      s: {
        to: [{ key_code: "s", modifiers: ["right_control", "right_option"] }],
      },
      u: {
        to: [{ key_code: "page_down" }],
      },
    },
    w: {
      // size
      d: {
        description: "Window: Hide",
        to: [{ key_code: "h", modifiers: ["right_command"] }],
      },
      hyphen: open("-g raycast://extensions/raycast/window-management/make-smaller"),
      equal_sign: open("-g raycast://extensions/raycast/window-management/make-larger"),

      // quadrants
      u: open("-g raycast://extensions/raycast/window-management/top-left-quarter"),
      i: open("-g raycast://extensions/raycast/window-management/top-right-quarter"),
      j: open("-g raycast://extensions/raycast/window-management/bottom-left-quarter"),
      k: open("-g raycast://extensions/raycast/window-management/bottom-right-quarter"),

      // halves
      h: open("-g raycast://extensions/raycast/window-management/left-half"),
      l: open("-g raycast://extensions/raycast/window-management/right-half"),

      // center
      c: open("-g raycast://extensions/raycast/window-management/center"),
      r: open("-g raycast://extensions/raycast/window-management/reasonable-size"),
      comma: open("-g raycast://extensions/raycast/window-management/almost-maximize"),
      m: open("-g raycast://extensions/raycast/window-management/maximize"),
      f: open("-g raycast://extensions/raycast/window-management/toggle-fullscreen"),

      // displays
      p: open("-g raycast://extensions/raycast/window-management/previous-display"),
      n: open("-g raycast://extensions/raycast/window-management/next-display"),
    },
    // x: {},
    // y: {},
  }),
];

const contents = {
  global: { show_in_menu_bar: false },
  profiles: [
    {
      name: "Default",
      complex_modifications: {
        rules,
      },
    },
  ],
};

Bun.write(FILE_NAME, JSON.stringify(contents, null, 2));
