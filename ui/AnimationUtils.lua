EnableGlobals()

function AnimateToAlpha(Element, Alpha, Time, CancelOldAnims)
    if CancelOldAnims then
        Element:completeAnimation()
    end

    Element:beginAnimation("keyframe", Time, false, false, CoD.TweenType.Linear)
    Element:setAlpha(Alpha)
end

function AnimateToRGB(Element, RGBTable, Time, CancelOldAnims) 
    if CancelOldAnims then
        Element:completeAnimation()
    end

    Element:beginAnimation("keyframe", Time, false, false, CoD.TweenType.Linear)
    Element:setRGB(RGBTable.R, RGBTable.G, RGBTable.B)
end

function GetCachedImage(imageName)
    if not CoD.CachedImages then
        CoD.CachedImages = {}
    end

    if not CoD.CachedImages[imageName] then
        CoD.CachedImages[imageName] = RegisterImage(imageName)
    end

    return CoD.CachedImages[imageName]
end