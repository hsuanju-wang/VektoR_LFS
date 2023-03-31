using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopTrigger : MonoBehaviour
{
    public PopSample popSample;
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("foot"))
        {
            popSample.popOut();
            this.GetComponent<Collider>().enabled = false;
        }
    }
}
