using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class DialogueManager : MonoBehaviour
{
    public GameObject[] dialogues;
    public int currentDialoguesIndex;
    public float introDelayedTime;

    [Header("UIs")]
    public TextMeshProUGUI dialogueUITxt;
    public GameObject dialoguePanel;

    [Header("Current dialogue info")]
    public string currentDialgoueTxt;
    public float dialogueWaitingTime =0f;
    public DialoguePiece dialoguePiece;
    public GameObject dialogueImage;

    AudioSource audioSource;
    public bool isDisplayingDialogue;

    private void Start()
    {
        isDisplayingDialogue = false;
        currentDialoguesIndex = 0;
        audioSource = GetComponent<AudioSource>();
        if (GameObject.Find("IntroDialogues"))
        {
            StartCoroutine(StartIntro());
        }
    }

    /// Start DialogueDisplay Coroutine 
    public void StartDialogue(GameObject dialogueObj, bool hasNextDialogue)
    {
        if (!isDisplayingDialogue)
        {
            isDisplayingDialogue = true;
            StartCoroutine(DialogueDisplay(dialogueObj, hasNextDialogue));
        }
        else
        {
            //Debug.Log("Not able to start dialogue");
        }
    }

    private IEnumerator DialogueDisplay(GameObject dialogueObj, bool hasNextDialogue)
    {
        OpenDialoguePanel();

        dialoguePiece = dialogueObj.GetComponentInChildren<DialoguePiece>();
    
        for (int i = 0; i < dialoguePiece.dialogues.Length; i++)
        {
            //Debug.Log("currentDialoguesIndex" + currentDialoguesIndex + " " + i);

            // play audio
            audioSource.clip = dialoguePiece.audioClips[i]; 
            audioSource.Play();

            // set UI Text
            currentDialgoueTxt = dialoguePiece.dialogues[i];
            dialogueUITxt.text = dialoguePiece.dialogues[i];

            // set images
            dialogueImage = dialoguePiece.images[i];
            if (dialogueImage != null)
            {
                dialogueImage.SetActive(true);
            }

            yield return new WaitForSeconds(audioSource.clip.length);
            yield return new WaitForSeconds(dialogueWaitingTime);

            // close Image
            if (dialogueImage != null)
            {
                dialogueImage.SetActive(false);
                dialogueImage = null;
            }

            if ( i == dialoguePiece.dialogues.Length - 1 )
            {
                isDisplayingDialogue = false;

                if (dialoguePiece.task == null) 
                {
                    if (hasNextDialogue) {
                        NextDialoguePiece();
                    }
                }
                else
                {
                    dialoguePiece.task.GetComponent<Task>().StartTask();
                }
            }
        }
    }

    public void NextDialoguePiece()
    {
        if (currentDialoguesIndex != dialogues.Length + 1)
        {
            if (dialogueImage != null)
            {
                dialogueImage.SetActive(false);
                dialogueImage = null;
            }
            currentDialoguesIndex++;
            StartDialogue(dialogues[currentDialoguesIndex], true);
        }
    }

    private void OpenDialoguePanel()
    {
        dialogueUITxt.text = "";
        dialoguePanel.SetActive(true);
    }

    private IEnumerator StartIntro()
    {
        yield return new WaitForSeconds(introDelayedTime);

        StartDialogue(GameObject.Find("IntroDialogues"), true);
    }

}
