# Effect
An [`Effect`](#effect) object represents code that runs while the dialogue is being shown. You can use them to change how content is shown to the player, or maybe you can use them to just run client-side code. The choice is yours.

## Static properties

## Static methods

## Constructors
### new(properties)

## Methods
### execute(executionProperties)
> [!WARNING]
> Themes intentionally yield until `executionProperties.continuePage()` is called. This gives the component some time to do what it needs to do; however, to the player, this can potentially give the appearance of the dialogue box freezing up.

Executes the provided, user-defined function and potentially returns a React component to show to the player.  

> **Returns**
> <br />[`ReactNode`](https://react.luau.page/api-reference/react/#reactcreateelement)?

### getBounds(initialWidth, maximumWidth)
Gets the expected space needed to fully execute the effect, giving tools like [`DialogueContentFitter`](/src/DialogueClientScript/Classes/DialogueContentFitter/README.md) some perspective without having to [execute](#executeexecutionproperties) the effect.
<!-- TODO: Split effect into more effects with this method. -->

> **Returns**
> <br />An array of [`Bounds`](#bounds).