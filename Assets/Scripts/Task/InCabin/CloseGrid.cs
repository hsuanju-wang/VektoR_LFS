using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CloseGrid : Task
{

    public float progressGapTime;
    public GameObject[] progressImg;
    public TextMeshProUGUI dialogueUITxt;

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
