# AI Usage Declaration
This project was developed with limited assistance from an AI-based tool. AI use was restricted to clarification, review, and refinement tasks. It did not replace independent design, implementation, or verification work.

## Task 1 - RTL Implementation (VHDL Timer)
AI assistance was used to:
 - Clarify VHDL syntax and best practices.
 - Review comments and improve code readability.

The timer architecture, state machine design, delay computation logic and reset strategy were designed, implemented and validated independently.

## Task 2 - Verification with VUnit
AI assistance was used to:
 - Review the structure of the VUnit testbench.
 - Suggest improvements to comments and test naming for clarity.
 - Add Python code to autogenerate a GTKWave-compatible waveform for debugging.

Testbench logic, self-checking assertions, and test scenarios were written and debugged independently.

## Task 3 - Continuous Integration (CI)
AI assistance was used to:
 - Set the correct environment in the workflow to match the system that I was using.
 - Select the correct GHDL mode

The CI structure, workflow separation, failure validation, and integration with the repository were implemented and tested independently.

## Task 4 (Stretch Goal) - Formal Verification
AI assistance was used to:
 - Explain and clarify PSL syntax and common property patterns.
 - Review the phrasing and structure of formal properties.
 - Suggest "Stop checking if reset is pressed during the wait" during "assert_done_timing" verification stage.

The selection of properties, environment assumptions, timing assertions, and wrapper architecture were defined and implemented independently to meet the task requirements.

## Documentation
AI assistance was used to:
 - Review grammar, spelling, and clarity of documentation
 - Suggest improvements to structure and formatting

All technical content accurately reflects the implemented design and verification results.

## AI Models Used
 - ChatGPT 5.2
 - Gemini 3
 - Copilot built into Visual Studio Code
    - Comment autocompletion was used.
    - The code autocomplete was ignored due to experience with its inaccuracy for HDL.

---
This declaration reflects the full extent of AI usage in this project.