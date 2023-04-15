using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Credit : MonoBehaviour
{
    public static Credit s;
    public float maxHeight;
    public float speed;

    private void Awake()
    {
        if (s != null && s != this)
        {
            Destroy(this);
        }
        else
        {
            s = this;
        }
    }

    public void Show()
    {
        StartCoroutine(CreditRise());
    }

    private IEnumerator CreditRise()
    {
        while (Vector3.Distance(new Vector3(this.transform.position.x, maxHeight, this.transform.position.z), this.transform.position) > 0.1f)
        {
            float step = speed * Time.deltaTime;
            this.transform.position += new Vector3(0f, speed * Time.deltaTime, 0f);
            // move sprite towards the target location
            yield return null;
        }
    }

    

}
