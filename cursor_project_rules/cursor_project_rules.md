
## 📘 Cursor Project Rules for Swift & Xcode Projects

### 🔧 General Workflow

1. **Use `cursor_project_rules` as the Knowledge Base**  
   Always refer to the `cursor_project_rules` folder to understand the context of the project. Do not code anything outside of the context provided. This folder contains the fundamental rules and guidelines that must be followed. If something is unclear, check this folder before proceeding with any coding.

2. **Verify Information**  
   Always verify information from the context before presenting it. Do not make assumptions or speculate without clear evidence.

3. **Follow `implementation-plan.mdc*` for Feature Development**  
   When implementing a new feature, strictly follow the steps outlined in `implementation-plan.mdc*`. Complete each step in order, and after finishing one, update it with `"Done"` and a two-line summary of what was done. This ensures a clear work log and transparent progress tracking.

4. **File-by-File Changes**  
   Make changes file-by-file to help identify issues incrementally.

5. **Single Chunk Edits**  
   Provide all edits in a single chunk per file. Avoid multi-step explanations or breaking a single file’s change into separate blocks.

### 💬 Communication Rules

6. **No Apologies**  
   Never include apologies.

7. **No Understanding Feedback**  
   Avoid comments like “Got it” or “I understand.”

8. **No Whitespace Suggestions**  
   Don’t suggest changes purely based on whitespace.

9. **No Summaries**  
   Don’t summarize changes unless explicitly asked to.

10. **No Inventions**  
    Do not invent changes beyond what is explicitly requested.

11. **No Unnecessary Confirmations**  
    Don’t ask for confirmation of information already provided.

### 🧠 Context & Code Awareness

12. **Preserve Existing Code**  
    Do not remove unrelated code or functionality. Maintain the existing structure unless explicitly told otherwise.

13. **Check Context-Generated File Content**  
    Always refer to the context-generated file to understand current implementations.

14. **Avoid Implementation Checks Unless Necessary**  
    Don’t ask the user to verify visible implementations unless a change affects critical functionality. In such cases, offer automated tests.

15. **No Unnecessary Updates**  
    Avoid suggesting updates if there are no actual changes.

16. **Provide Real File Links**  
    Always reference real files, not context-generated paths.

17. **Don’t Discuss Current Implementation Unnecessarily**  
    Only refer to current implementations when it's needed to explain the impact of a change.

### ✍️ Code Quality Guidelines

18. **Use Explicit Variable Names**  
    Favor descriptive and meaningful variable names over short or ambiguous ones.

19. **Follow Consistent Coding Style**  
    Match the existing style used in the project (spacing, naming, etc.).

20. **Prioritize Performance**  
    Suggest performance-optimized solutions when possible.

21. **Security-First Approach**  
    Always consider potential security risks when modifying or introducing code.

22. **Test Coverage**  
    Include or suggest appropriate unit tests for new or modified code.

23. **Error Handling**  
    Implement robust error handling and logging where needed.

24. **Modular Design**  
    Promote reusable, loosely coupled components to improve maintainability.

25. **Version Compatibility**  
    Ensure compatibility with the specified Swift and Xcode versions. If conflicts arise, suggest backward-compatible alternatives.

26. **Avoid Magic Numbers**  
    Replace hardcoded values with clearly named constants.

27. **Consider Edge Cases**  
    Always consider and handle edge conditions.

28. **Use Assertions Where Applicable**  
    Use assertions to validate assumptions and catch issues early during development.

### 🍏 Swift & Xcode Specific Guidelines

29. **Follow Swift Idioms**  
    Write idiomatic Swift—use `guard`, `let` immutability, avoid force unwraps, favor value types, and use protocol-oriented approaches when appropriate.

30. **Add Meaningful Comments for Non-Obvious Logic**  
    When implementing non-trivial logic, include concise comments to aid maintainability.

31. **Consider Thread Safety in Async Code**  
    Be mindful of concurrency, especially when using GCD or Swift Concurrency. Ensure safe access to shared resources.

## ✅ How to Set This as Your Cursor Rules

1. **Create a `cursor_project_rules` folder** in the root of your project if it doesn’t already exist.

2. Inside that folder, **create a file named `cursor_project_rules.md`**.

3. Paste the above content into the file and save.

4. Open Cursor. It should automatically detect and apply the rules in `cursor_project_rules.md`. You’ll see the rules being referenced in AI suggestions and file interactions.

5. (Optional) Add this folder and file to version control (e.g., Git) to ensure the rules travel with the project.
