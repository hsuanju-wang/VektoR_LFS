using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class BootReactivate : MonoBehaviour
{
    public bool isStartGuide;

    [Header("UIs")]
    public GameObject reactivatePanel;
    public TextMeshProUGUI dialogueUITxt;

    private bool isStartCheckInCircle;
    // Start is called before the first frame update
    void Start()
    {
        isStartGuide = false;
        isStartCheckInCircle = false;
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void StartBootReactivate()
    {

        if (EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            dialogueUITxt.text = "";
        }
        else
        {
            dialogueUITxt.text = "";
        }
        reactivatePanel.SetActive(true);
    }

    
}
