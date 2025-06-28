for _, Module: ModuleScript in (
    shared.Sequencing(script.Parent.Parent.Tabs.Universal:GetChildren()) :: array
) do
    require(Module)
end

return {}
