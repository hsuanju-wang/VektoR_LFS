using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutsideDM : DialogueManager
{
    public static OutsideDM s;

    public bool dialogueIsEnd = false;
    public AudioClip sampleCollectedClip;

    private void Awake()
    {
        if (s != null && s != this)
        {
            Destroy(this);
        }
        else
        {
            s = this;
        }
    }
    // Start is called before the first frame update
    protected override void Start()
    {
        base.Start();
        StartCoroutine(StartIntro());
        //StartCoroutine(CloseIntro());
    }
    private IEnumerator StartIntro()
    {
        yield return new WaitForSeconds(introDelayedTime);
        StartDialogue(dialogues[0]);
    }

/*    private IEnumerator CloseIntro()
    {
        yield return new WaitForSeconds(24f);
        dialoguePanel.SetActive(false);
    }*/

    public void CloseDialogueUI()
    {
        dialoguePanel.SetActive(false);
    }

    public void PlaySampleCollected()
    {
        audioSource.clip = sampleCollectedClip;
        audioSource.Play();
    }
    
}
