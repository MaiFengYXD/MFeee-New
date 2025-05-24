for _, Module: ModuleScript in (
    wax.shared.Sequencing(script.Parent.Parent.Tabs.Universal:GetChildren()) :: table
) do
    (require :: Function)(Module)
end

return {}
