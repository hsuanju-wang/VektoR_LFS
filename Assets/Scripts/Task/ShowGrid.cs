using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;

public class ShowGrid : Task
{
    //public GameObject grid;

    public override void StartTask()
    {
        base.StartTask();
        Valve.VR.OpenVR.Chaperone.ForceBoundsVisible(true);
        base.EndTask();
        Destroy(this.gameObject);
    }
}
