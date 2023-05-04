using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowGrid : Quest
{
    public override void StartQuest()
    {
        base.StartQuest();
        Valve.VR.OpenVR.Chaperone.ForceBoundsVisible(true);
        base.EndQuest();
    }
}
