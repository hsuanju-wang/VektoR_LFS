using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckedInCircle : Task
{
    public bool isStartTask = false;
    public override void StartTask()
    {
        base.StartTask();
        isStartTask = true;
    }

    private void Update()
    {
        if (isStartTask && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            base.EndTask();
            isStartTask = false;
        }
        Destroy(this.gameObject);
    }
}
