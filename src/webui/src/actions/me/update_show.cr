class Me::UpdateShow < BrowserAction
  post "/me" do
    SaveTranscompileTask.create(params) do |operation, transcompile_task|
      if operation.saved?
        puts "here"
      end
      if transcompile_task
        flash.success = "Task saved"
        html ShowPage, operation: operation
      else
        flash.failure = "Something went wrong"
        html ShowPage, operation: operation, output: "Please try again."
      end
    end
  end
end