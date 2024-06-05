// https://dev.to/ryansolid/building-a-reactive-library-from-scratch-1i0p

type Subscription = {
  dependencies: Set<Set<Subscription>>;
  runEffect: () => void;
};
type Subscriptions = Set<Subscription>;

const context: Subscription[] = [];

function signal<T>(value?: T) {
  const subscriptions: Subscriptions = new Set();

  const read = () => {
    const latestContext = context.at(-1);
    if (latestContext) {
      subscriptions.add(latestContext);
      latestContext.dependencies.add(subscriptions);
    }
    return value;
  };

  const write = (newValue: T) => {
    value = newValue;
    // We clone the list so that new subscriptions added in
    // the course of this execution do not affect this run
    for (const subscription of [...subscriptions]) {
      subscription.runEffect();
    }
  };

  return [read, write] as const;
}

function cleanup(subscription: Subscription) {
  for (const dep of subscription.dependencies) {
    dep.delete(subscription);
  }
  subscription.dependencies.clear();
}

function effect(cb: () => void) {
  const subscription = {
    runEffect: () => {
      cleanup(subscription);
      context.push(subscription);
      cb(); // missing error handling
      context.pop();
    },
    dependencies: new Set<Set<Subscription>>(),
  };

  subscription.runEffect();
}

function derived(cb: () => void) {
  const [derived, setDerived] = signal();
  effect(() => setDerived(cb()));
  return derived;
}

/* example */

const [firstName] = signal("John");
const [lastName, setLastName] = signal("Doe");
const [showFullName, setShowFullName] = signal(true);

const displayName = derived(() => {
  if (!showFullName()) return firstName();
  return `${firstName()} ${lastName()}`;
});

effect(() => console.log("My name is", displayName()));
// My name is John Doe

setShowFullName(false);
// My name is John

setLastName("Smith");
setLastName("Legend");
setShowFullName(true);
// My name is John
