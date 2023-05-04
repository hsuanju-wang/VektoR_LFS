using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowSuccessSuit : Quest
{
    //public GameObject dialoguePanel;
    public GameObject rightControllerHint;
    public GameObject errorSuit;
    public GameObject successSuit;

    public bool isStarted = false; // Usd in ControllerInCabin.cs
    public bool isDone = false; // Usd in ControllerInCabin.cs

    public override void StartQuest()
    {
        base.StartQuest();
        isStarted = true;
    }

    public override void EndQuest()
    {
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
        base.EndQuest();
    }


    private IEnumerator ShowSuitActivated()
    {
        successSuit.SetActive(true);
        yield return new WaitForSeconds(2f);
        successSuit.SetActive(false);
        base.EndQuest();

        /*        if (dialogueManager.isDisplayingDialogue)
                {
                    StartCoroutine(WaitToDisplayDialogue());
                }
                else
                {
                    base.EndQuest();
                }*/
    }
}
