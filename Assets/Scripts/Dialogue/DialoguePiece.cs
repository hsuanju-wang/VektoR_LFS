using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Store each dialogue piece and task
/// </summary>

[System.Serializable]
public class DialoguePiece: MonoBehaviour
{
    /// <summary>
    /// This class stores the values on each dialogue pieces.
    /// It will be used in DialogueManager.cs.
    /// </summary>
    
    public string[] dialogues; //Must
    public AudioClip[] audioClips; //Must

    public bool notShowDialogPanel;

    [Header("If close panel when dialgoue piece ends")]
    public bool closePanel;

    [Header("Optional but length has to match dialogues")]
    public GameObject[] images;

    [Header("Optional")]
    public GameObject dialoguePanel; // If null, use default dialogue panel
    public Quest quest;
    //public Task task;

    private void Start()
    {
        quest = GetComponentInChildren<Quest>();
    }

}

