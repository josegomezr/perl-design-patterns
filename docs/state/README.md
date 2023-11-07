<!-- MarkdownTOC -->

- State Pattern
- UML Goodies
  - State Diagram
  - Class Diagram

<!-- /MarkdownTOC -->

State Pattern
===

From: https://refactoring.guru/design-patterns/state

> State is a behavioral design pattern that lets an object alter its behavior when
its internal state changes. It appears as if the object changed its class.

---

This implementation is a small State Machine representing a `Car` that can:

* Turn on
* Turn off
* Drive
  
    * Accelerate
    * Break

Each State is represented by an _adjetive_ (e.g. `Driving`) and every transition
as a **verb** (`park`, `drive`). I don't know if that's good or bad, but it
works for my understanding of the pattern.

UML Goodies
===

State Diagram
---

```mermaid
stateDiagram-v2
    [*] --> TurnedOff : Start

    TurnedOff --> TurnedOn : Turn On
    TurnedOn --> TurnedOff : Turn Off

    TurnedOn --> Driving   : Drive
    Driving --> Driving  : Accelerate
    Driving --> Driving  : Break
    Driving --> TurnedOn  : Park

    TurnedOff --> [*] : Finish
```

Class Diagram
---

```mermaid
classDiagram
  Car o-- AbstractState

  AbstractState <|-- Driving
  AbstractState <|-- TurnedOff
  AbstractState <|-- TurnedOn

  namespace PDP {
    class Car {
      -state AbstractState
      -speed number
      +transition_to(new_state AbstractState) void
      +speed(speed number) number
      +accelerate(new_speed number) void
      +hit_breaks() void
      +state(state ?: AbstractState) void

      +turn_on() void
      +turn_off() void
      +drive() void
      +park() void
    }
  }

  namespace PDP__State {
    class AbstractState {
      -context Car
      +context(context Car) Car
      +can_transition_to(new_state AbstractState) bool

      +turn_on() void
      +turn_off() void
      +drive() void
      +park() void
    }

    class Driving {
      +turn_on() void
      +turn_off() void
      +drive() void
      +park() void
    }

    class TurnedOff {
      +turn_on() void
      +turn_off() void
      +drive() void
      +park() void
    }

    class TurnedOn {
      +turn_on() void
      +turn_off() void
      +drive() void
      +park() void
    }
  }
```