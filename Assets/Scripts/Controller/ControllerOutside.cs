using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;

public class ControllerOutside : MonoBehaviour
{
    //For Debug
    public TextMeshPro debugTxt;

    public SteamVR_Action_Boolean trackpadClicked;
    public SteamVR_Action_Boolean rightTriggerClicked;
    public SteamVR_Action_Boolean leftTriggerClicked;

    public SteamVR_Input_Sources inputSource;

    [Header("Scan Settings")]
    public ScanHandler scanHandler;

    [Header("Collect Settings")]
    public GameObject laser;
    public CollectHandler collectHandler;


    [HideInInspector] public InSpaceshipDM dialogueManager;

    private void Start()
    {
        
    }

    void OnEnable()
    {
        trackpadClicked.AddOnStateDownListener(OnTrackpadClicked, inputSource);
        rightTriggerClicked.AddOnStateDownListener(OnRightTriggerClicked, inputSource);
        rightTriggerClicked.AddOnStateUpListener(OnRightTriggerReleased, inputSource);
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
        //debugTxt.text = "Right Trigger was pressed";
        laser.SetActive(true);
        //Collect();
    }

    private void OnRightTriggerReleased(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        //debugTxt.text = "Not pressed";
        laser.SetActive(false);
        collectHandler.isCollecting = false;
    }



/*    private void Collect()
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
    }*/
}
