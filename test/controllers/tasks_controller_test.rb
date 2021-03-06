require "test_helper"

describe TasksController do
  # Note to students:  Your Task model **may** be different and
  #   you may need to modify this.
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test", 
    completed: false
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
    
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do

      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do
      # Arrange
      # Note to students:  Your Task model **may** be different and
      #   you may need to modify this.
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed: false,
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed).must_equal task_hash[:task][:completed]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end
###################################################
  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      get edit_task_path(task.id)

      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant task" do

      invalid_id = "INVALID ID"
      get edit_task_path(invalid_id)

      must_respond_with :redirect
    end
  end

  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    it "can update an existing task" do
      task_change = {
        task: {
          name: "name has changed",
          description: "description has changed",
        },
      }

      task_id = task.id
      # patch task_path(task.id), params: task_change
      expect {
        patch task_path(task.id), params: task_change
      }.must_change "Task.count", 0

      edited_task = Task.find_by(id: task_id)
      expect(edited_task.name).must_equal task_change[:task][:name]
      expect(edited_task.description).must_equal task_change[:task][:description]

      must_respond_with :redirect
      must_redirect_to task_path(task.id)
    end

    it "will redirect to the root page if given an invalid id" do
      task_change = {
        task: {
          name: "name has changed",
          description: "description has changed",
        },
      }

      invalid_id = "INVALID ID"
      patch task_path(invalid_id), params: task_change

      must_respond_with :redirect

    end
  end

  # Complete these tests for Wave 4
  describe "destroy" do
    it "returns a 404 if the task is not found" do 
      invalid_id = "INVALID ID"
      expect {
        delete task_path(invalid_id)
      }.wont_change "Task.count"
 
      must_respond_with :not_found
    end

    it "can delete a task" do 
      new_task = Task.create(name: "Do Homework")
      expect {
        delete task_path(new_task.id)
      }.must_change "Task.count", -1

      must_respond_with :redirect
      must_redirect_to tasks_path
    end 

  end

  # Complete for Wave 4
  describe "mark_done" do
    it "changes the completed and saves a completion date" do 
      new_task = Task.create(name: "Do Homework", completed: false)
      
      patch marked_task_path(new_task.id)
      new_task = Task.find_by(id: new_task.id)
      expect(new_task.completed).must_equal true
      expect(new_task.completion_date).must_equal Date.today
    end

    it "returns a 404 if the task is not found" do 
      invalid_id = "INVALID ID"
      patch marked_task_path(invalid_id)
      must_respond_with :not_found
    end
  end
end