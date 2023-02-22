using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloseGrid : Task
{
    //public GameObject grid;

    public override void StartTask()
    {
        base.StartTask();
        Valve.VR.OpenVR.Chaperone.ForceBoundsVisible(false);
        //grid.SetActive(false);
        EndTask();
    }
}
