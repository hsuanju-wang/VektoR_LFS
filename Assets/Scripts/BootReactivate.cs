using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class BootReactivate : MonoBehaviour
{
    [Header("UIs")]
    public BootReactivatePanel reactivatePanel;

    [Header("Dialogues")]
    public DialoguePiece activateSuitDialogue;
    public DialoguePiece checkInCircleDialogue;

    public float sentenceShowTime;
    private bool isStartCheck; // Start Check in circle
    public bool isChecked; // Is Checked in circle

    // Start is called before the first frame update
    void Start()
    {
        isChecked = false;
        isStartCheck= false;
    }

    // Update is called once per frame
    void Update()
    {
        if (isStartCheck && !isChecked)
        {
            if (EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
            {
                //Activate suit Dialogue
                StartCoroutine(ShowReactivateDialogue());
            }
        }
    }

    public void StartBootReactivate()
    {
        reactivatePanel.Show();
        if (EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            //Activate suit Dialogue
            StartCoroutine(ShowReactivateDialogue());
        }
        else
        {
            isStartCheck = true;
            //Step in circle Dialgoue before Activate suit Dialogue
            reactivatePanel.ShowText("");
            StartCoroutine(ShowCheckInCircleDialogue());
        }
        
    }

    public IEnumerator ShowReactivateDialogue()
    {
        isChecked = true;
        yield return new WaitForSeconds(sentenceShowTime);
        reactivatePanel.HideBootImage();
        for (int i = 0; i < activateSuitDialogue.dialogues.Length; i++)
        {
            reactivatePanel.ShowText(activateSuitDialogue.dialogues[i]);
            yield return new WaitForSeconds(sentenceShowTime);
        }
    }

    public IEnumerator ShowCheckInCircleDialogue()
    {
        yield return new WaitForSeconds(sentenceShowTime);
        reactivatePanel.HideBootImage();
        for (int i = 0; i < checkInCircleDialogue.dialogues.Length; i++)
        {
            reactivatePanel.ShowText(checkInCircleDialogue.dialogues[i]);
            yield return new WaitForSeconds(sentenceShowTime);
        }
    }

    public void BootReactivated()
    {
        StartCoroutine(ShowReactived());
    }

    public IEnumerator ShowReactived()
    {
        reactivatePanel.ShowBootActivated();
        yield return new WaitForSeconds(sentenceShowTime);
        reactivatePanel.Hide();
        isChecked = false;
        isStartCheck = false;
    }


}
