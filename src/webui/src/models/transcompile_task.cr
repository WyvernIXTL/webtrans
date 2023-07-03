class TranscompileTask < BaseModel
  table do
    column input_code : String = ""
    column output_code : String = ""
    column completed : Bool = false
    column priority : Int32 = 2
  end
end
