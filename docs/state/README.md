State Pattern
===

From: https://refactoring.guru/design-patterns/state

> State is a behavioral design pattern that lets an object alter its behavior when
its internal state changes. It appears as if the object changed its class.

---

Table of Contents
===

- [Implementation Details](#implementationddetails)
- [UML Goodies](#uml-goodies)
  - [State Diagram](#state-diagram)
  - [Class Diagram](#class-diagram)

---

Implementation Details
===

A small State Machine representing a `Car` that can:

* Turn on
* Turn off
* Drive
    * Accelerate
    * Break

Each State is represented by an _adjetive_ (e.g. `Driving`) and every transition
as a **verb** (`park`, `drive`).

<small>**Writer's Note:** _I don't know if that's good or bad, but it works for
my understanding of the pattern._</small>

The secret of this pattern is that the Actor (`Car`) shifts the logic of
transitioning states to each state.

Each state *must* define all transitions and block the ones that are invalid.

**For example:** In our scenario _[also see the diagrams below]_, the rules
  don't not allow for:

  * `Car` drives when it's turned off: `State::TurnedOff` validates this.
  * `Car` parks when it's turned off: `State::TurnedOff` validates this.
  * `Car` drives when it's driving (double enter): `State::Driving` validates
    this.

UML Goodies
===

State Diagram
---

![State Diagram: See Source in ./state-diagram.plantuml](./state-diagram.png)

Class Diagram
---

![Class Diagram: See Source in ./class-diagram.plantuml](./class-diagram.png)