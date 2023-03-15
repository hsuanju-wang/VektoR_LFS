using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InSpaceshipDM : DialogueManager
{
    [Header("In Spaceship popups and audios")]
    public GameObject firstStepPopup;
    public GameObject scanPopup;
    public AudioClip firstStepAudioClip;
    public AudioClip scanAudioClip;

    protected override void Start()
    {
        base.Start();
        StartCoroutine(OpenIntroPopUp());
        //StartConsoleDialogues();
    }

    private IEnumerator OpenIntroPopUp()
    {
        yield return new WaitForSeconds(introDelayedTime);
        OpenPopUp(firstStepPopup, firstStepAudioClip);
    }

    private void OpenPopUp(GameObject popup, AudioClip popUpAudioClip)
    {
        popup.SetActive(true);
        audioSource.clip = popUpAudioClip;
        audioSource.Play();
    }

    public void CloseFirstStepPopup()
    {
        firstStepPopup.SetActive(false);
    }

    public void OpenScanPopup()
    {
        OpenPopUp(scanPopup, scanAudioClip);
    }

    public void CloseScanPopup()
    {
        scanPopup.SetActive(false);
    }

    public void StartConsoleDialogues()
    {
        OpenDialoguePanel();
        StartDialogue(dialogues[0]);
    }
}
