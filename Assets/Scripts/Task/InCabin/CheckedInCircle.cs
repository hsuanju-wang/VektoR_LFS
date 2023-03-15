using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckedInCircle : Task
{
    public DialoguePiece notInCircleDialogue;

    public bool taskIsEnded;

    public override void StartTask()
    {
        base.StartTask();
        taskIsEnded = false;
        if (EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            EndTask();
        }
        else
        {
            dialogueManager.StartDialogue(notInCircleDialogue);
        }
    }

    private void Update()
    {
        if (!taskIsEnded && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            EndTask();
        }
    }

    public override void EndTask()
    {
        taskIsEnded = true;
        base.EndTask();
        //Destroy(this.gameObject);
    }
}
