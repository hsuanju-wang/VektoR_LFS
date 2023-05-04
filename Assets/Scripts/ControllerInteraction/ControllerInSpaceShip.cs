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

    void OnEnable()
    {
        trackpadClicked.AddOnStateDownListener(OnTrackpadClicked, inputSource);
    }

    private void OnDisable()
    {
        trackpadClicked.RemoveOnStateDownListener(OnTrackpadClicked, inputSource);

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
}
