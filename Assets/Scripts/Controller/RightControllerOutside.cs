using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RightControllerOutside : MonoBehaviour
{
    public ControllerOutside controllerInteraction;
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            //controllerInteraction.isCollectOn = true;
            //controllerInteraction.collectObj = other.gameObject;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            //controllerInteraction.isCollectOn = false;
            //controllerInteraction.collectObj = null;
        }
    }
}
