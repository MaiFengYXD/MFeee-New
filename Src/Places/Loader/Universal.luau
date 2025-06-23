for _, Module: ModuleScript in (
    wax.shared.Sequencing(script.Parent.Parent.Tabs.Universal:GetChildren()) :: array
) do
    require(Module)
end

return {}
