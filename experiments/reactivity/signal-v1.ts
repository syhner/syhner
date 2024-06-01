let subscriber: (() => void) | undefined;

function signal<T>(value?: T) {
  const subscriptions = new Set<Function>();

  return {
    get value() {
      if (subscriber) subscriptions.add(subscriber);
      return value as T;
    },
    set value(newValue: T) {
      value = newValue;
      subscriptions.forEach((fn) => fn());
    },
  };
}

function effect(cb: () => void) {
  subscriber = cb;
  cb(); // Runs the effect, which also adds the subscription
  subscriber = undefined;
}

function derived(cb: () => void) {
  const derived = signal();
  effect(() => (derived.value = cb()));
  return derived;
}

const count = signal(0);
const doubled = derived(() => count.value * 2);
effect(() => console.log(`value: ${count.value}`)); // 0

count.value = 1; // 1
console.log(`doubled: ${doubled.value}`); // 2

count.value = 3; // 3
console.log(`doubled: ${doubled.value}`); // 6
