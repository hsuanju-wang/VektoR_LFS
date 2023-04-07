using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;

public class ControllerOutside : MonoBehaviour
{
    public SteamVR_Action_Boolean trackpadClicked;
    public SteamVR_Action_Boolean rightTriggerClicked;
    public SteamVR_Action_Boolean leftTriggerClicked;

    public SteamVR_Input_Sources inputSource;

    public ScanHandler scanHandler;
    public TextMeshProUGUI txtNum;
    public bool isCollectOn;
    public GameObject collectObj;
    public int collectedSamples;
    [HideInInspector] public InSpaceshipDM dialogueManager;

    private void Start()
    {
        collectedSamples = 0;
    }

    void OnEnable()
    {
        trackpadClicked.AddOnStateDownListener(OnTrackpadClicked, inputSource);
        rightTriggerClicked.AddOnStateDownListener(OnRightTriggerClicked, inputSource);
        leftTriggerClicked.AddOnStateDownListener(OnLeftTriggerClicked, inputSource);

        dialogueManager = GameObject.FindObjectOfType<InSpaceshipDM>();
    }

    private void OnDisable()
    {
        trackpadClicked.RemoveOnStateDownListener(OnTrackpadClicked, inputSource);
        rightTriggerClicked.RemoveOnStateDownListener(OnRightTriggerClicked, inputSource);
        leftTriggerClicked.RemoveOnStateDownListener(OnLeftTriggerClicked, inputSource);
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

    private void OnLeftTriggerClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        //debugTxt.text = "Left Trigger was pressed";
        Debug.Log("Left Trigger was pressed");
        scanHandler.Scan();
    }

    private void OnRightTriggerClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        //debugTxt.text = "RightTrigger was pressed";
        Debug.Log("Right Trigger was pressed");
        Collect();
    }

    private void Collect()
    {
        if (isCollectOn)
        {
            // Animation ??
            collectObj.SetActive(false);
            isCollectOn = false;
            collectObj = null;
            collectedSamples++;
            txtNum.text = collectedSamples.ToString() + "/3";
        }
    }
}
