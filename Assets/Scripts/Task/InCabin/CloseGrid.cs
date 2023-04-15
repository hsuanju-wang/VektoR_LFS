using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CloseGrid : Task
{

    public float progressGapTime;
    public GameObject[] progressImg;
    public TextMeshProUGUI dialogueUITxt;

    public AudioClip gridAudioClip;
    public AudioSource audioSource;

    public override void StartTask()
    {
        base.StartTask();
        Valve.VR.OpenVR.Chaperone.ForceBoundsVisible(false);
        //grid.SetActive(false);
        EndTask();
    }

    public override void EndTask()
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
        base.EndTask();
    }
}
