// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title To-Do List Smart Contract
/// @author Akash
/// @notice This contract lets each user manage their own list of tasks.
/// @dev Demonstrates arrays, mappings, modifiers, and struct usage.
contract ToDoList {
    struct Task {
        string description;
        bool isCompleted; 
    }

    // Mapping from user address to their list of tasks
    mapping(address => Task[]) private tasksByUser;

    /// @dev Ensures the given task index exists for the caller
    modifier validTaskIndex(uint256 _taskIndex) {
        require(_taskIndex < tasksByUser[msg.sender].length, "Invalid task index");
        _;
    }

    /// @notice Add a new task to your to-do list
    /// @param _description The description of the task
    function addTask(string memory _description) public {
        tasksByUser[msg.sender].push(Task(_description, false));
    }

    /// @notice Mark one of your tasks as completed
    /// @param _taskIndex The index of the task to mark complete
    function markTaskComplete(uint256 _taskIndex) public validTaskIndex(_taskIndex) {
        tasksByUser[msg.sender][_taskIndex].isCompleted = true;
    }

    /// @notice Mark one of your tasks as incomplete
    /// @param _taskIndex The index of the task to mark incomplete
    function markTaskIncomplete(uint256 _taskIndex) public validTaskIndex(_taskIndex) {
        tasksByUser[msg.sender][_taskIndex].isCompleted = false;
    }

    /// @notice Get all tasks you’ve created
    /// @return The array of tasks belonging to the caller
    function getMyTasks() public view returns (Task[] memory) {
        return tasksByUser[msg.sender];
    }

    /// @notice Update the description of an existing task
    /// @param _taskIndex The index of the task to update
    /// @param _updatedDescription The new description for the task
    function updateTask(uint256 _taskIndex, string memory _updatedDescription) public validTaskIndex(_taskIndex) {
        tasksByUser[msg.sender][_taskIndex].description = _updatedDescription;
    }

    /// @notice Delete a task from your list (preserves task order)
    /// @param _taskIndex The index of the task to delete
    function deleteTask(uint256 _taskIndex) public validTaskIndex(_taskIndex) {
        uint256 _totalTasks = tasksByUser[msg.sender].length;

        for (uint i = _taskIndex; i < _totalTasks - 1; i++) {
            tasksByUser[msg.sender][i] = tasksByUser[msg.sender][i + 1];
        }

        tasksByUser[msg.sender].pop();
    }
}
