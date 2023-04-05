using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutsideDM : DialogueManager
{
    // Start is called before the first frame update
    protected override void Start()
    {
        base.Start();
        StartCoroutine(StartIntro());
        StartCoroutine(CloseIntro());
    }
    private IEnumerator StartIntro()
    {
        yield return new WaitForSeconds(introDelayedTime);
        StartDialogue(dialogues[0]);
    }

    private IEnumerator CloseIntro()
    {
        yield return new WaitForSeconds(24f);
        dialoguePanel.SetActive(false);
    }
}
