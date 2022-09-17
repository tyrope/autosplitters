state("Autonauts") {}

startup {
    vars.Log = (Action<object>)(output => print("[Autonauts Autosplit] " + output));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
}

init {
    vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
    {
        var SpeedrunData = helper.GetClass("Assembly-CSharp", "SpeedrunData");
        vars.Unity.Make<bool>(SpeedrunData.Static, SpeedrunData["m_timeTicking"]).Name = "timeTicking";
        vars.Unity.Make<int>(SpeedrunData.Static, SpeedrunData["m_highestFolk"]).Name = "tierReached";
        return true;
    });

    vars.Unity.Load(game);
}

update {
    if(!vars.Unity.Loaded) return false;

    vars.Unity.Update();
}

start {
    return vars.Unity["timeTicking"].Current;
}

isLoading {
    return !vars.Unity["timeTicking"].Current;
}

split {
    if(vars.Unity["tierReached"].Current > vars.Unity["tierReached"].Old){
        return true;
    }
}

