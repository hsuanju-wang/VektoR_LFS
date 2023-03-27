using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowControllerHint : Task
{
    public GameObject rightControllerHint;
    public GameObject errorSuit;
    public GameObject successSuit;

    public override void StartTask()
    {
        base.StartTask();
        rightControllerHint.SetActive(true);
        PlayerPrefs.SetString("ShowControllerHint", "Done");
        errorSuit.SetActive(true);
        CloseTxt();
        
    }

    public override void EndTask() // Can have status to check if boots are activated early
    {
        // Check status and Change dialogue piece to early activated dialogue
        errorSuit.SetActive(false);
        rightControllerHint.SetActive(false);
        StartCoroutine(ShowSuitActivated());
    }

    private IEnumerator WaitToDisplayDialogue()
    {
        while (dialogueManager.isDisplayingDialogue)
        {
            yield return null;
        }
        base.EndTask();
    }

    private void CloseTxt()
    {
        dialogueManager.dialogueUITxt.text = "";
        dialogueManager.dialogueImage.SetActive(false);
    }

    private IEnumerator ShowSuitActivated()
    {
        successSuit.SetActive(true);
        yield return new WaitForSeconds(2f);
        successSuit.SetActive(false);

        if (dialogueManager.isDisplayingDialogue)
        {
            StartCoroutine(WaitToDisplayDialogue());
        }
        else
        {
            base.EndTask();
        }
    }
}
