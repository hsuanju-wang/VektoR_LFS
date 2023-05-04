using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Quest : MonoBehaviour
{
    [HideInInspector] public DialogueManager dialogueManager;
    public virtual void StartQuest()
    {
        dialogueManager = FindObjectOfType<DialogueManager>();
    }

    public virtual void EndQuest()
    {
        dialogueManager.NextDialoguePiece();
    }
}
