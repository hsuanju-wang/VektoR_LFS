using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CloseGrid : Quest
{

    public float progressGapTime;
    public GameObject[] progressImg;
    public TextMeshProUGUI dialogueUITxt;

    public AudioClip gridAudioClip;
    public AudioSource audioSource;

    public override void StartQuest()
    {
        base.StartQuest();
        Valve.VR.OpenVR.Chaperone.ForceBoundsVisible(false);
        EndQuest();
    }

    public override void EndQuest()
    {
        StartCoroutine(ShowProgress());
    }

    public IEnumerator ShowProgress()
    {
        audioSource.clip = gridAudioClip;
        audioSource.Play();
        dialogueUITxt.text = "";
        for (int i = 0; i < progressImg.Length; i++)
        {
            progressImg[i].SetActive(true);
            yield return new WaitForSeconds(progressGapTime);
            progressImg[i].SetActive(false);
        }
        base.EndQuest();
    }
}
