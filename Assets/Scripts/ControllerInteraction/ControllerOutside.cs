using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;

public class ControllerOutside : MonoBehaviour
{
    /// <summary>
    /// This class handles the all the interaction on the controllers: triggers, trackpad.
    /// </summary>
    
    public static ControllerOutside s;
    
    public SteamVR_Action_Boolean trackpadClicked;
    public SteamVR_Action_Boolean rightTriggerClicked;
    public SteamVR_Action_Boolean leftTriggerClicked;

    public SteamVR_Input_Sources inputSource;
    public bool dialogueIsEnd;
    public TriggerAnim leftControllerQuest;

    [HideInInspector] public bool isRTriggerClicked = false;
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
        dialogueIsEnd = false;
    }

    void OnEnable()
    {
        trackpadClicked.AddOnStateDownListener(OnTrackpadClicked, inputSource);
        rightTriggerClicked.AddOnStateDownListener(OnRightTriggerClicked, inputSource);
        rightTriggerClicked.AddOnStateUpListener(OnRightTriggerReleased, inputSource);
        leftTriggerClicked.AddOnStateDownListener(OnLeftTriggerClicked, inputSource);
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
            EktoVRManager.S.ekto.StopSystem();
        }
    }

    private void OnLeftTriggerClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        //Debug.Log("Left Trigger was pressed");

        if (!dialogueIsEnd)
        {
            if (leftControllerQuest.isStarted && !leftControllerQuest.isEnd)
            {
                ScanHandler.s.Scan();
                leftControllerQuest.EndQuest();
            }
        }
        else
        {
            ScanHandler.s.Scan();
        }
    }

    private void OnRightTriggerClicked(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        isRTriggerClicked = true;
        if (!ScanHandler.s.scannerActive) // Turn on the laser and collect Panel if the player when scanner is not active
        {
            CollectHandler.s.collectPanel.SetActive(true);
            Laser.s.LaserOn();
        }
    }

    private void OnRightTriggerReleased(SteamVR_Action_Boolean fromAction, SteamVR_Input_Sources fromSource)
    {
        Laser.s.LaserOff();
        CollectHandler.s.collectPanel.SetActive(false);
        isRTriggerClicked = false;
        CollectHandler.s.isCollecting = false;
    }
}
