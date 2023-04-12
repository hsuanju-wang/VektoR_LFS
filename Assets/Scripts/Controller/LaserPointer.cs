using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LaserPointer : MonoBehaviour
{
    public CollectHandler collectHandler;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            Debug.Log("sample trigger");
            collectHandler.isCollecting = true;
            collectHandler.StartDissolveSample(other.gameObject);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            Debug.Log("sample trigger exit");
            collectHandler.isCollecting = false;
        }
    }
}
