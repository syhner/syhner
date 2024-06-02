function observable<T>(value: T) {
  const subscribers = new Set<Function>();

  return {
    update(newValue: T) {
      value = newValue;
      this.notify(value);
    },

    subscribe(fn: (value: T) => unknown) {
      subscribers.add(fn);
      return { unsubscribe: () => subscribers.delete(fn) };
    },

    notify(value: T) {
      subscribers.forEach((fn) => fn(value));
    },
  };
}

let count = observable(0);
const logCount = count.subscribe((count) => console.log(count));

count.update(1); // logs 1
count.update(2); // logs 2
logCount.unsubscribe();
count.update(3); // does not log
