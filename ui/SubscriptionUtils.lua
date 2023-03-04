EnableGlobals()

function SubscribeToVisibilityBit(InstanceRef, HudRef, Widget, VisiblityBit)
    Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. VisiblityBit), function(ModelRef)
        HudRef:updateElementState(Widget, {
        name = "model_validation",
        menu = HudRef,
        modelValue = Engine.GetModelValue(ModelRef),
        modelName = "UIVisibilityBit." .. VisiblityBit
    })
    end)
end

function SubscribeToModelAndUpdateState(InstanceRef, HudRef, Widget, ModelName)
    Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), ModelName), function(ModelRef)
        HudRef:updateElementState(Widget, {
        name = "model_validation",
        menu = HudRef,
        modelValue = Engine.GetModelValue(ModelRef),
        modelName = ModelName
    })
    end)
end

function LinkToElementModelAndUpdateState(HudRef, Widget, ModelName, NeedsSubscription)
    Widget:linkToElementModel(Widget, ModelName, NeedsSubscription, function(ModelRef)
        HudRef:updateElementState(Widget, {
        name = "model_validation",
        menu = HudRef,
        modelValue = Engine.GetModelValue(ModelRef),
        modelName = ModelName
    })
    end)
end

function SubscribeToMultipleModels(Widget, Models, Callback)
    for index=1, #Models do
        Widget:subscribeToModel(Models[index], Callback)
    end
end

function SubscribeToMultipleModelsByName(Widget, InstanceRef, ModelNames, Callback)
    for index=1, #ModelNames do
        Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), ModelNames[index]), Callback)
    end
end

function SubscribeToModelByName(Widget, InstanceRef, ModelName, Callback)
    Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), ModelName), Callback)
end