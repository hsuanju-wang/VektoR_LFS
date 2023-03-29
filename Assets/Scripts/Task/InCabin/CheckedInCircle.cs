using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckedInCircle : Task
{
    public DialoguePiece notInCircleDialogue;

    public bool taskIsEnded;
    public bool taskIsStarted;

    public GameObject errorSuit;
    public GameObject bigUI;
    public Task nextTask;

    private AudioSource audioSource;

    public override void StartTask()
    {
        base.StartTask();
        audioSource = GetComponent<AudioSource>();
        taskIsEnded = false;
        taskIsStarted = false;
        if (EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            EndTask();
        }
        else
        {
            dialogueManager.StartDialogue(notInCircleDialogue);
            taskIsStarted = true;
        }
    }

    private void Update()
    {
        if (taskIsStarted && !taskIsEnded && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.LEFT) && EktoVRManager.S.ekto.IsBootInStartingZone(EKTO_Unity_Plugin.Handedness.RIGHT))
        {
            EndTask();
        }
    }

    public override void EndTask()
    {
        taskIsEnded = true;
        StartCoroutine(ChangeDisplay());
        //Destroy(this.gameObject);
    }

    public IEnumerator ChangeDisplay()
    {
        bigUI.SetActive(false);
        errorSuit.SetActive(true);
        audioSource.Play();
        yield return new WaitForSeconds(audioSource.clip.length);
        nextTask.StartTask();
    }
}
