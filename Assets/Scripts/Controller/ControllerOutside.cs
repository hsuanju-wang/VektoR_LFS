using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;

public class ControllerOutside : MonoBehaviour
{
    public static ControllerOutside s;
    
    public TextMeshPro debugTxt;
    public SteamVR_Action_Boolean trackpadClicked;
    public SteamVR_Action_Boolean rightTriggerClicked;
    public SteamVR_Action_Boolean leftTriggerClicked;

    public SteamVR_Input_Sources inputSource;

    [Header("Collect Settings")]
    public GameObject laser;

    [HideInInspector] public InSpaceshipDM dialogueManager;
    [HideInInspector] public bool triggerClicked = false;
    private void Awake()
    {
        if (s != null && s != this)
        {
            Destroy(this);
        }
        else
        {
            s = this;
        }
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
        ScanHandler.s.Scan();
    }

    private void OnRightTriggerClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        //debugTxt.text = "Right Trigger was pressed";
        triggerClicked = true;
        if (!ScanHandler.s.scannerActive)
        {
            laser.SetActive(true);
        }
        //Collect();
    }

    private void OnRightTriggerReleased(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        //debugTxt.text = "Not pressed";
        laser.SetActive(false);
        triggerClicked = false;
        CollectHandler.s.isCollecting = false;
    }

    public void LaserOn()
    {
        laser.SetActive(true);
    }
}
