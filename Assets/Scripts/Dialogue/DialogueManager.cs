using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class DialogueManager : MonoBehaviour
{
    /// <summary>
    /// This class handles displaying dialogues.
    /// </summary>
    /// 

    [Header("All Dialogue pieces")]
    public DialoguePiece[] dialogues;

    [Header("Dialogue Display Settings")]
    public float introDelayedTime;
    public float btwSentenceWaitTime; // waiting time bewteen sentences
    public float endDelayedTime;
    public GameObject defaultDialoguePanel;

    [Header("Current Dialogue Info (For Debug) ")]
    [SerializeField] private DialoguePiece currDialoguePiece;
    [SerializeField] private GameObject dialoguePanel;
    [SerializeField] private TextMeshProUGUI dialogueUITxt;
    [SerializeField] private int currentDialoguesIndex;
    [SerializeField] private GameObject dialogueImage;
    public bool isDisplayingDialogue;

    protected AudioSource audioSource;

    private void Awake()
    {
        dialogues = GetComponentsInChildren<DialoguePiece>();
    }

    private void Start()
    {
        isDisplayingDialogue = false;
        currentDialoguesIndex = 0;
        audioSource = GetComponent<AudioSource>();

        // Start First Dialogue
        StartCoroutine(StartFirstDialogue());
    }

    protected virtual IEnumerator StartFirstDialogue()
    {
        yield return new WaitForSeconds(introDelayedTime);
        StartDialogue(dialogues[0]);
    }

    /// Start DialogueDisplay Coroutine 
    public void StartDialogue(DialoguePiece dialogPiece)
    {
        isDisplayingDialogue = true;
        StartCoroutine(DialogueDisplay(dialogPiece));
    }

    private IEnumerator DialogueDisplay(DialoguePiece dialogPiece)
    {
        currDialoguePiece = dialogPiece.GetComponent<DialoguePiece>();
        SetUIs();
        OpenDialoguePanel();

        for (int i = 0; i < currDialoguePiece.dialogues.Length; i++)
        {
            // play audio
            audioSource.clip = currDialoguePiece.audioClips[i]; 
            audioSource.Play();

            // set UI Text
            dialogueUITxt.text = currDialoguePiece.dialogues[i];

            // set images
            dialogueImage = currDialoguePiece.images[i];
            if (dialogueImage != null)
            {
                dialogueImage.SetActive(true);
            }

            yield return new WaitForSeconds(audioSource.clip.length);
            yield return new WaitForSeconds(btwSentenceWaitTime);

            // close Image
            if (dialogueImage != null)
            {
                dialogueImage.SetActive(false);
                dialogueImage = null;
            }
        } // End of displaying Dialogue

        isDisplayingDialogue = false;

        if (currDialoguePiece.closePanel) StartCoroutine(WaitToCloseDialogue());// Check if close panel in the end

        if (currDialoguePiece.quest == null) // Check if has quest
        {
            NextDialoguePiece();
        }
        else
        {
            currDialoguePiece.quest.StartQuest();
        }
    }

    public void  NextDialoguePiece()
    {
/*        bool isDialogueStarted = false;
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
        return isDialogueStarted;*/

        currentDialoguesIndex++;
        if (currentDialoguesIndex == dialogues.Length) // End of all dialogue pieces
        {
            // CloseDialoguePanel();
        }
        else
        {
            StartDialogue(dialogues[currentDialoguesIndex]);
        }
    }

    protected void OpenDialoguePanel()
    {
        if (!currDialoguePiece.notShowDialogPanel)
        {
            dialogueUITxt.text = "";
            dialoguePanel.SetActive(true);
        }
    }

    public void CloseDialoguePanel()
    {
        dialogueUITxt.text = "";
        dialoguePanel.SetActive(false);
    }

    private IEnumerator WaitToCloseDialogue()
    {
        yield return new WaitForSeconds(endDelayedTime);
        dialogueUITxt.text = "";
        dialoguePanel.SetActive(false);
    }

    private void SetUIs()
    {
        // Set Dialogue Panel
        if (currDialoguePiece.dialoguePanel != null) 
        {
            dialoguePanel = currDialoguePiece.dialoguePanel;
        }
        else
        {
            dialoguePanel = defaultDialoguePanel; // if null, use default dialogue panel
        }

        // Set Dialogue UI Text
        dialogueUITxt = dialoguePanel.GetComponentInChildren<TextMeshProUGUI>();
    }

}
