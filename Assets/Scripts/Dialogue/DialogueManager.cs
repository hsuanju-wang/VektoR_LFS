using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class DialogueManager : MonoBehaviour
{
    public DialoguePiece[] dialogues;

    [Header("Dialogue Settings")]
    public float introDelayedTime;
    public float dialogueWaitingTime;

    [Header("UIs")]
    public TextMeshProUGUI dialogueUITxt;
    public GameObject dialoguePanel;

    [Header("Current dialogue info")]
    public int currentDialoguesIndex;
    public DialoguePiece currentDialoguePiece;
    public GameObject dialogueImage;
    public bool isDisplayingDialogue;

    protected AudioSource audioSource;
    protected virtual void Start()
    {
        isDisplayingDialogue = false;
        currentDialoguesIndex = 0;
        audioSource = GetComponent<AudioSource>();
    }

    /// Start DialogueDisplay Coroutine 
    public bool StartDialogue(DialoguePiece dialogPiece)
    {
        if (!isDisplayingDialogue)
        {
            isDisplayingDialogue = true;
            StartCoroutine(DialogueDisplay(dialogPiece));
            return true;
        }
        else
        {
            return false;
            //Debug.Log("Dialogue is still going on");
        }
    }

    private IEnumerator DialogueDisplay(DialoguePiece dialogPiece)
    {
        OpenDialoguePanel();

        currentDialoguePiece = dialogPiece.GetComponent<DialoguePiece>();
    
        for (int i = 0; i < currentDialoguePiece.dialogues.Length; i++)
        {
            //Debug.Log("currentDialoguesIndex" + currentDialoguesIndex + " " + i);

            // play audio
            audioSource.clip = currentDialoguePiece.audioClips[i]; 
            audioSource.Play();

            // set UI Text
            dialogueUITxt.text = currentDialoguePiece.dialogues[i];

            // set images
            dialogueImage = currentDialoguePiece.images[i];
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

            if (i == currentDialoguePiece.dialogues.Length - 1) // Last dialogue in dialogue piece 
            {
                isDisplayingDialogue = false;

                if (currentDialoguePiece.task == null) // Check if has task
                {
                    if (currentDialoguePiece.autoNextDialogue) { 
                        NextDialoguePiece();
                    }
                }
                else
                {
                    currentDialoguePiece.task.StartTask();
                }
            }
        }
    }

    public bool NextDialoguePiece()
    {
        bool isDialogueStarted = false;
        if (currentDialoguesIndex != dialogues.Length + 1)
        {
            if (dialogueImage != null)
            {
                dialogueImage.SetActive(false);
                dialogueImage = null;
            }
            currentDialoguesIndex++;
            isDialogueStarted = StartDialogue(dialogues[currentDialoguesIndex]);
        }
        return isDialogueStarted;
    }

    protected void OpenDialoguePanel()
    {
        dialogueUITxt.text = "";
        dialoguePanel.SetActive(true);
    }

}
