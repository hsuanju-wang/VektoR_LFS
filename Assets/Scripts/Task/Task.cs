using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Task: MonoBehaviour
{
    [HideInInspector]public DialogueManager dialogueManager;

    public virtual void StartTask() {
        dialogueManager = FindObjectOfType<DialogueManager>();
    }

    public virtual void EndTask()
    {
        StartCoroutine(WaitNextDialogPiece());
    }

    public IEnumerator WaitNextDialogPiece()
    {
        while (!dialogueManager.NextDialoguePiece())
        {
            yield return null;
        }
    }

}
