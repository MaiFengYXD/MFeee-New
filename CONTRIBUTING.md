<h1 align="center">📖Contributing Guide📖</h1>

>[!NOTE]
>When creating commit messages follow the [Conventional Commits Standard](https://www.conventionalcommits.org/en/v1.0.0/).

---

## Code Style for MFeee~ New

To ensure a consistent, readable, and maintainable codebase for MFeee~ New, all contributions must strictly follow these style guidelines.

<br>

## 💡Core Design Principles

Beyond specific formatting and naming rules, we follow three core design principles to build a robust and scalable project: **high cohesion**, **low coupling**, and **high reusability**. Adhering to these principles ensures our codebase remains easy to understand, test, and expand.

+ **High Cohesion**: Each script or module should focus on doing **one thing and doing it well**. For example, a module for user data should only contain functions related to user data (like fetching or updating), not functions for sending emails or processing payments. This makes the code’s purpose clear and reduces complexity.
+ **Low Coupling**: Modules should be as independent as possible. **Minimize dependencies** between different parts of the code. When you change one module, it should not require changes in many other modules. This makes the system more flexible and reduces the risk of introducing bugs.
+ **High Reusability**: Write code that can be used in different places. By creating **generic, self-contained components**, we can avoid duplicating code and accelerate development. For instance, a well-designed UI component can be used on multiple pages without being rewritten each time.

## 🔡Naming Conventions

+ **PascalCase for New Identifiers:** Please use **PascalCase** for naming all **newly declared variables, types, module scripts, functions, tables used as classes/structs**, and other general identifiers. This consistency significantly improves overall script readability and navigability.
    - **Discouraged:** Please **do not use `UPPER_SNAKE_CASE`** (e.g., `MY_CONSTANT`) for constants. Instead, name constants using **PascalCase** like any other new variable (e.g., `MyConstantValue`).
+ **Original Casing for Cached Globals/Library Functions:** When creating local caches for global variables, built-in functions, or library functions (e.g., `string.find`, `task.defer`), retain their **original casing** for better recognition.

## ✍️Formatting

+ **Indentation:** Use **4 spaces** for indentation. **Tabs are strictly forbidden.**
+ **No Indentation on Empty Lines:** Ensure that **empty lines do not contain any whitespace (spaces or tabs)** for indentation.
+ **Newline at End of File:** All script files **must end with a single newline character**.

<br>

+ **Vertical Alignment for Bindings and Definitions (Recommended, with Discretion):** For significantly improved readability and visual consistency, **vertical alignment for value bindings and definitions is strongly recommended**. This applies to:
    - **Assignment operators (`=`)**: For consecutive variable assignments, table literals, and configuration tables.
    - **Type definitions (`:` and `::`)**: For aligning keys, values, and type annotations within `type` declarations.
    - **Parallel local variable declarations**: When declaring multiple local variables from different sources.
    - **Discretionary Use:** While highly encouraged, this alignment may be omitted if it requires **excessive whitespace** (e.g., many dozens of spaces) or **significantly reduces overall readability** in specific contexts. Prioritize code clarity and maintainability.

    <br>

    - **Recommended Vertical Alignment Examples:**
        1. Consecutive Variable Assignments (New Variables - PascalCase)
        ```luau
        local UserName = "Alice"
        local UserAge  = 30
        local City     = "Singapore"

        local MaxAttempts = 5 --/ Constant named with PascalCase

        ```

        2. Type Definition Alignment (PascalCase for fields)
        ```luau
        type NotificationSide = (
            | "Center"
            | "Top"
            | "Bottom"
            | "TopLeft"
            | "TopRight"
            | "BottomLeft"
            | "BottomRight"
            | "Left"
            | "Right"
        )

        type NotificationInfo = {
            Title:       string?,
            Text:        string,
            Description: string,
            Time:        number | Instance,
            Duration:    number | Instance,
            SoundId:     number | string,
            Side:        NotificationSide
        }

        ```

        3. Parallel Local Variable Declarations and Destructuring (Cached Globals - Original Casing)
        ```luau
        local pcall, xpcall, typeof, string_find, table_insert
            = pcall, xpcall, typeof, string.find, table.insert

        local      IsA,      GetDescendants
            = game.IsA, game.GetDescendants

        ```
<br>

+ **Multi-line Expressions (Mandatory Parentheses):** For **any expression that spans multiple lines**, regardless of its complexity or whether Luau syntax strictly requires it, **it must be wrapped in parentheses `()`**. The opening parenthesis `(` should be on the first line, followed by a newline, with the content indented. The closing parenthesis `)` should then be on a new line, aligning with the opening line's indentation. This rule applies uniformly to:
    - The right-hand side of **assignment expressions**.
    - **`and` or `or` expressions**. For these logical operators, ensure the operator (`and` / `or`) stays on the **preceding line's end**. This maintains visual flow and leverages syntax highlighting, as the line begins with a variable-colored identifier and smoothly transitions to the operator.
    - The expression part of **`return` statements**.
    - Any other expression intentionally split across lines for readability.

    <br>

    - **Recommended Multi-line Formatting with Parentheses:**
        1. Multi-line assignment expression:
        ```luau
        local MyVariable = (
            ValueOne + ValueTwo
            / ValueThree
        )

        ```

        2. Multi-line complex boolean expression
        ```luau
        return InputObject.UserInputState == Change and (
            InputObject.UserInputType == MouseMovement or
            not OnlyMouse and (
                InputObject.UserInputType == Touch
            )
        )

        ```

        3. Multi-line return expression
        ```luau
        return (
            UserData.IsValid and
            UserData.IsActive
        )

        ```

        4. Multi-line type definition
        ```luau
        type NotificationInfo = {
            Title:       string?,
            Text:        string,
            Description: string,
            Time:        number | Instance,
            Duration:    number | Instance,
            SoundId:     number | string,
            Side:        NotificationSide
        }

        ```

        5. Multi-line function call arguments
        ```luau
        local Result = CalculateComplexValue(
            InputData,
            ConfigurationSettings,
            AdditionalOptions.EnableFeatureX,
            OtherParameters.Mode
        )

        ```
<br>

+ **Type Annotations (Type Hints):** As Luau supports type annotations, please **make extensive use of them** for function parameters, return values, and variable declarations wherever possible. This significantly improves script maintainability, allows for better static analysis, enhances readability, and helps in catching potential errors early.
    - **Recommended Usages:**
    ```luau
    local function CalculateDamage(BaseDamage: number, Multiplier: number): number
        local FinalDamage = BaseDamage * Multiplier
        return FinalDamage
    end

    local function GetUserData(UserId: string): {Name: string, Age: number}
        --/ ... implementation
        return {Name = "John Doe", Age = 25}
    end

    local Players = {} :: {string}

    ```

## 👻Commenting

Consistent and clear commenting is crucial for understanding complex scripts. Follow these guidelines for different comment types:
+ **Inline Comments (Side Remarks):**
    - Use `--/` followed by a space and your comment for concise side remarks or clarifications on the same line as code. This distinct style improves readability for quick notes.
    - You may also use standard `--` comments if they appear more visually appealing or are better suited for the context.

    <br>

    - **Example:**
    ```luau
    local UserName = "Alice"     --/ User's full name
    local UserAge  = 30          --/ Age in years
    local City     = "Singapore" -- This is a standard comment, useful for longer explanations.

    ```

+ **Code Section Comments (Minor Partitions):**
    - For commenting on a specific section or logical block of code, use `--//` followed by a space, the section name in **PascalCase**, and then another `//`.
    - These comments act as clear delimiters for smaller, distinct code areas.

    <br>

    - **Example:**
    ```luau
    --// Main Logics
    local function ProcessData(Data: any): any
        -- ...
    end

    --// Helpers
    local function ValidateInput(Input: any): boolean
        -- ...
    end

    ```

+ **Major Section Comments (Large Partitions):**
    - For larger, overarching sections or modules within a script, use `--//` followed by a space, the section name with **Each Word Capitalized** (e.g., `Setup`), another space, and then **two additional slashes `//` at the end of the line**. This creates a visually distinct separator for major code divisions.

    <br>

    - **Example:**
    ```luau
    --// Setup //
    local MyModule = {}
    --/ ... initialization code

    --// Core Logic //
    local function RunApplication(): ()
        --/ ... main application logic
    end

    ```

+ **Multi-line Comments (Docstrings / Block Comments):**
    - For multi-paragraph explanations, docstrings, or temporarily disabling large blocks of code, use `--[[` at the start and `--]]` at the end.
    - The content within the multi-line comment **must be indented by 4 spaces**.
    - Crucially, the closing `--]]` **must include two hyphens `--` just before the `]]`**, ensuring consistent visual pairing and potential tool compatibility.

    <br>

    - **Example:**
    ```luau
    --[[
        Important 4-space indentation
        Followed by content

        ~~bla bla bla~~
    --]]

    ```
