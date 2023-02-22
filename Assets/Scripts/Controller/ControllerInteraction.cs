using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;

public class ControllerInteraction : MonoBehaviour
{
    public SteamVR_Action_Boolean trackpadClicked;
    public SteamVR_Action_Boolean rightTriggerClicked;
    public SteamVR_Action_Boolean leftTriggerClicked;

    public SteamVR_Input_Sources inputSource;
    public GameObject task;
    public TextMeshProUGUI debugTxt;

    public GameObject notInCircleDialogue;
    [HideInInspector] public DialogueManager dialogueManager;


    void OnEnable()
    {
        trackpadClicked.AddOnStateDownListener(OnTrackpadClicked, inputSource);

        dialogueManager = GameObject.FindObjectOfType<DialogueManager>();
    }

    private void OnDisable()
    {
        trackpadClicked.RemoveOnStateDownListener(OnTrackpadClicked, inputSource);
    }

    private void OnTrackpadClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        debugTxt.text = "trackpad was pressed";
        if (EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            if (!EktoVRManager.S.ekto.IsSystemActivated() && PlayerPrefs.GetString("ShowControllerHint") == "Done")
            {
                debugTxt.text = "System Activates";
                EktoVRManager.S.ekto.StartSystem();
                task.GetComponent<Task>().EndTask();
            }
            else
            {
                debugTxt.text = "System already Activates";
                //EktoVRManager.S.ekto.StopSystem();
            }
        }
        else
        {
            if (!EktoVRManager.S.ekto.IsSystemActivated())
            {
                dialogueManager.StartDialogue(notInCircleDialogue);
                debugTxt.text  = "Boots not in circle";
            }
            
        }
        Debug.Log("Trigger was pressed or released");

    }

}
