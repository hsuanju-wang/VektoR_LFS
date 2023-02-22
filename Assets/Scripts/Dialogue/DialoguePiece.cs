using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Store each dialogue piece and task
/// </summary>

[System.Serializable]
public class DialoguePiece: MonoBehaviour
{
    public bool autoNextDialogue;
    public string[] dialogues;
    public GameObject task;

    public AudioClip[] audioClips;
    public GameObject[] images;
}

