using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;

public class ControllerInSpaceShip : MonoBehaviour
{
    public SteamVR_Action_Boolean trackpadClicked;
    public SteamVR_Action_Boolean rightTriggerClicked;
    public SteamVR_Action_Boolean leftTriggerClicked;

    public SteamVR_Input_Sources inputSource;
    //public TextMeshProUGUI debugTxt;

    //public GameObject rightControllerTask;
    //public GameObject leftControllerTask;
    //public GameObject notInCircleDialogue;
    [HideInInspector] public InSpaceshipDM dialogueManager;


    void OnEnable()
    {
        trackpadClicked.AddOnStateDownListener(OnTrackpadClicked, inputSource);
        //rightTriggerClicked.AddOnStateDownListener(OnRightTriggerClicked, inputSource);
        //leftTriggerClicked.AddOnStateDownListener(OnLeftTriggerClicked, inputSource);

        dialogueManager = GameObject.FindObjectOfType<InSpaceshipDM>();
    }

    private void OnDisable()
    {
        trackpadClicked.RemoveOnStateDownListener(OnTrackpadClicked, inputSource);
        //rightTriggerClicked.RemoveOnStateDownListener(OnRightTriggerClicked, inputSource);
        //leftTriggerClicked.RemoveOnStateDownListener(OnLeftTriggerClicked, inputSource);
    }

    private void OnTrackpadClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        if (!EktoVRManager.S.ekto.IsSystemActivated())
        {
            EktoVRManager.S.ekto.StartSystem();

        }
        else
        {
            //EktoVRManager.S.ekto.StopSystem();
        }
    }

/*    private void OnLeftTriggerClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        //debugTxt.text = "Left Trigger was pressed";
        Debug.Log("Left Trigger was pressed");
        if (leftControllerTask.GetComponent<ControllerTask>().isTaskStart && !leftControllerTask.GetComponent<ControllerTask>().isTaskEnd)
        {
            leftControllerTask.GetComponent<Task>().EndTask();
        }

    }*/

/*    private void OnRightTriggerClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        //debugTxt.text = "RightTrigger was pressed";
        Debug.Log("Right Trigger was pressed");
        if (rightControllerTask.GetComponent<ControllerTask>().isTaskStart && !rightControllerTask.GetComponent<ControllerTask>().isTaskEnd)
        {
            rightControllerTask.GetComponent<Task>().EndTask();
        }
    }*/
}
