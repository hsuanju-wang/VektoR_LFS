using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;

public class ControllerInCabin : MonoBehaviour
{
    public SteamVR_Action_Boolean trackpadClicked;
    public SteamVR_Input_Sources inputSource;

    [Header("Show Success Suit quest")]
    public ShowSuccessSuit quest;

    public GameObject newStatusHud;
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
            if (quest.isDone)
            {
                EktoVRManager.S.ekto.StartSystem();
            }

            if (quest.isStarted)
            {
                EktoVRManager.S.ekto.StartSystem();
                quest.EndQuest();
                newStatusHud.SetActive(true);
            }
        }
        else
        {
            //EktoVRManager.S.ekto.StopSystem();
        }
    }

}
