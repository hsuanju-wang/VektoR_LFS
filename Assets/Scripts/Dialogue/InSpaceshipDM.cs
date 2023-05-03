using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class InSpaceshipDM : DialogueManager
{
    [Header("In Spaceship popups and audios")]
    public GameObject firstStepPopup;
    public GameObject scanPopup;
    public AudioClip firstStepAudioClip;
    public AudioClip firstStepAudioClip2;
    public AudioClip scanAudioClip;

    public TextMeshProUGUI firstPopupTxt;
    public string firstPopupDialogue2;

    protected override void Start()
    {
        base.Start();
        StartCoroutine(OpenIntroPopUp());
        //StartConsoleDialogues();
    }

    private IEnumerator OpenIntroPopUp()
    {
        yield return new WaitForSeconds(introDelayedTime);
        firstStepPopup.SetActive(true);
        audioSource.clip = firstStepAudioClip;
        audioSource.Play();
        yield return new WaitForSeconds(audioSource.clip.length);

        firstPopupTxt.text = firstPopupDialogue2;
        audioSource.clip = firstStepAudioClip2;
        audioSource.Play();
        yield return new WaitForSeconds(audioSource.clip.length);


        yield return new WaitForSeconds(5f);
        CloseFirstStepPopup();
        //OpenPopUp(firstStepPopup, firstStepAudioClip);
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
